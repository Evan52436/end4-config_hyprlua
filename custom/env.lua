
-- Force WebKitGTK into single-process mode and bypass sandbox stalls
hl.env("WEBKIT_FORCE_SANDBOX", "0")
hl.env("WEBKIT_USE_SINGLE_WEB_PROCESS", "1")
