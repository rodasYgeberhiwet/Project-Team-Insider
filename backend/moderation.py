import json
import logging
import os
import re
import time
from typing import Dict, Any, Optional

import google.generativeai as genai
from dotenv import load_dotenv

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()
API_KEY = "AIzaSyAWWr8AAA2jVkcM8Su4NbGdTQlLuEfno"
if not API_KEY:
    raise RuntimeError("API_KEY not found in environment")

genai.configure(api_key=API_KEY)
model = genai.GenerativeModel("gemini-2.5-flash")

ALLOWED_DECISIONS = {"APPROVE", "WARNING", "REJECT"}


def _extract_json(text):
    """
    Try several heuristics to extract JSON from the model's raw text.
    Returns a dict on success, or None on failure.
    """
    if not text:
        return None

    try:
        return json.loads(text)
    except Exception:
        pass

    match = re.search(r"\{.*\}", text, flags=re.DOTALL)
    if match:
        candidate = match.group(0)
        try:
            return json.loads(candidate)
        except Exception:
            # 3) Attempt to normalize single quotes to double quotes (best-effort)
            normalized = candidate.replace("'", '"')
            try:
                return json.loads(normalized)
            except Exception:
                return None
    return None


def _validate_result(obj):
    """
    Validate:
    { "decision": "APPROVE|WARNING|REJECT", "reason": str, "confidence": number 1-10 }
    Returns normalized dict on success, else None.
    """
    if not isinstance(obj, dict):
        return None

    decision = obj.get("decision")
    if isinstance(decision, str):
        decision = decision.strip().upper()
    else:
        return None

    if decision not in ALLOWED_DECISIONS:
        return None

    reason = obj.get("reason", "")
    if not isinstance(reason, str):
        reason = str(reason)

    confidence = obj.get("confidence")
    try:
        confidence = float(confidence)
    except Exception:
        # If missing or unparsable, set conservative default
        confidence = 5.0

    # Clamp confidence to 1-10
    confidence = max(1.0, min(10.0, confidence))

    return {"decision": decision, "reason": reason.strip(), "confidence": confidence}


def moderate_text(text: str, retries: int = 2, retry_delay: float = 0.5) -> Dict[str, Any]:
    """
    Moderate a single review text.

    Returns a dict: { "decision": "APPROVE|WARNING|REJECT", "reason": str, "confidence": number 1-10 }

    Behavior:
    - Sends a strict, deterministic prompt to the model (temperature=0 implied by instruction).
    - Attempts multiple parses of the model output before falling back.
    - Falls back to a conservative REJECT if parsing/validation repeatedly fail.
    """
    prompt = f"""
You are a STRICT moderation system for a college app review platform.
Categorize the review into exactly ONE of: "APPROVE", "WARNING", or "REJECT".

Rules:
- "APPROVE": Neutral, helpful, opinion-based, or constructive criticism.
- "WARNING": Slightly rude or negative but NOT targeting a protected class or a specific person.
- "REJECT": Contains profanity, insults, harassment, hate speech, doxxing, threats, or discriminatory content.

Respond only with valid JSON and nothing else, EXACTLY in this shape:
{{
  "decision": "APPROVE" | "WARNING" | "REJECT",
  "reason": "short explanation (1-2 sentences)",
  "confidence": number between 1 and 10 (10 = most confident)
}}

Review: "{text}"
"""

    last_exception = None
    for attempt in range(1, retries + 2):
        try:
            resp = model.generate_content(prompt)
            raw = getattr(resp, "text", None) or str(resp)
            parsed = _extract_json(raw)
            if parsed:
                validated = _validate_result(parsed)
                if validated:
                    return validated
                else:
                    logger.debug("Parsed JSON failed validation: %s", parsed)
            else:
                logger.debug("Could not extract JSON from model output: %s", raw)

        except Exception as exc:
            last_exception = exc
            logger.warning("Moderation API call failed on attempt %d: %s", attempt, exc)

        if attempt <= retries:
            time.sleep(retry_delay)

    logger.error(
        "Moderation failed after %d attempts. Falling back to conservative REJECT. Last error: %s",
        retries + 1,
        last_exception,
    )
    return {"decision": "REJECT", "reason": "Could not parse moderation result", "confidence": 10.0}