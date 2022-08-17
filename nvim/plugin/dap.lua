require("dapui").setup()

require("dap-python").setup("/opt/homebrew/bin/python3.8")
require("dap-python").test_runner = "unittest"
