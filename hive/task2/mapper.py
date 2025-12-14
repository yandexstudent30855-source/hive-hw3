#!/usr/bin/env python3
import sys, json, ast

def to_str(v):
    if v is None:
        return None
    if isinstance(v, bool):
        return "True" if v else "False"
    return str(v).strip('"')

def try_parse_nested(s: str):
    s = s.strip()
    if s.startswith("{") and s.endswith("}"):
        try:
            obj = ast.literal_eval(s)
            if isinstance(obj, dict):
                return obj
        except Exception:
            return None
    return None

def flatten(prefix, value, out):
    if value is None:
        return
    if isinstance(value, dict):
        for k, v in value.items():
            flatten(f"{prefix}.{k}", v, out)
        return
    if isinstance(value, str):
        nested = try_parse_nested(value)
        if nested is not None:
            flatten(prefix, nested, out)
            return
        v = to_str(value)
    else:
        v = to_str(value)

    if v is None:
        return
    out.append(f"{prefix}:{v}")

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        obj = json.loads(line)
    except Exception:
        continue

    bid = obj.get("business_id")
    if not bid:
        continue

    cats = obj.get("categories") or ""
    if "Restaurants" not in cats:
        continue

    attrs = obj.get("attributes") or {}
    if not isinstance(attrs, dict):
        continue

    tags = []
    for k, v in attrs.items():
        flatten(k, v, tags)

    for tag in tags:
        print(f"{bid}\t{tag}")
