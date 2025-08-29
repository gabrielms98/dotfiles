echo "Installing LSP servers globally..."

brew install lua-language-server # lua_ls
npm i -g css-variables-language-server # css_variables
npm install -g @angular/language-server # angular_ls
npm install -g @tailwindcss/language-server
npm install -g pyright # pyright
npm install -g emmet-ls # emmet_ls
npm install -g vscode-langservers-extracted # eslint, html, json, css
npm install -g @vtsls/language-server # vtsls
pip install black # python formatter
pip install "python-lsp-server[all]"
