const owner = "tutugrande1235"
const repo = "tutugrande1235-DTD"
const issue_number = process.env.ISSUE_NUMBER
const comment = process.env.COMMENT_BODY
const token = process.env.GITHUB_TOKEN

let reply = ""
const cbody = comment.split("@")
const user = cbody[0] || "User"
const to = cbody[1] || "User"
const c = cbody[2] || "nil"

if (!c || !user || !to){
  process.exit(0)
}

console.log("user:", user)
console.log("body:", c)

if (c.includes("test")) {
  reply = `dont test me @${user}!`
} else if (c.includes("bad")) {
  reply = `@${user} dont be SUCK!`
}

if (reply) {
  const form = `System@${user}@${reply}`
  const execSync = require("child_process").execSync
  const cmd = `curl -s -X POST -H "Authorization: token ${token}" -H "User-Agent: DOT-Bot" -d '{"body":"${form}"}' https://api.github.com/repos/${owner}/${repo}/issues/${issue_number}/comments`
  console.log("Executando:", cmd)
  const result = execSync(cmd).toString()
  console.log(result)
}