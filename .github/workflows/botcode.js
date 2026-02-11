async function main(){
const owner = "tutugrande1235"
const repo = "tutugrande1235-DTD"
const issue_number = 1
const comment = context.payload.comment.body
let reply = ""
const cbody = comment.split("@")
const user = cbody[0]
let form = ""
const c = cbody[1]

if (!c || !user){
  return
}

console.log("user: " + user + "\nbody: " + c)

if (c.includes("test")){
  reply = `dont test me @${user}!`
} else if (!user) {
  reply = `@${user} commented on the issue without use the app!`
} else if (c.includes("bad") && c.includes("package")) {
  reply = `@${user} dont be SUCK!`
}

if (reply){
  form = `System@${reply}`
}

await github.issues.createComment({
  owner: owner,
  repo: repo,
  issue_number: issue_number,
  body: form
})

}

main()