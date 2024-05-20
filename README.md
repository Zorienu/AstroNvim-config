# AstroNvim Template

**NOTE:** This is for AstroNvim v4+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository

```shell
git clone https://github.com/<your_user>/<your_repository> ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```

#### VSCode JS debugger
##### Auto installation does not work properly, follow these steps:
- go to `~/.local/share/nvim/lazy/vscode-js-debug`
- `npm install`
- `npx gulp vsDebugServerBundle`
- `mv dist out`
##### For terminating a session (does not work out of the box):
- go to `~/.local/share/nvim/lazy/nvim-dap/lua/dap.lua`
- add the class member `PID` to the class `Session`
- in the `run_in_terminal` function add:
```
lsession.PID = vim.fn.jobpid(jobid) -- added line
lsession:response(request, {
  success = true,
  body = {
    processId = vim.fn.jobpid(jobid),
  },
})
```
- in the `Session:close()` method add:
```
if (self.PID) then
  os.execute('kill' .. self.PID)
end
```
