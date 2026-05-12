-- firenvim#install(0) doesn't recognize Helium browser.
-- Manually create the native messaging host manifest:
--   cp ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/firenvim.json \
--      ~/Library/Application\ Support/net.imput.helium/NativeMessagingHosts/firenvim.json

return {
  'glacambre/firenvim',
  build = ":call firenvim#install(0)"
}
