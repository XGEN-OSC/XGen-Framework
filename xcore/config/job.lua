---@class Config
Config = Config or {}

---@type number the maximum amount of jobs a player can have
Config.maxJobs = 2

---@type number the interval (in minutes) at which players get their paycheck
Config.paycheckInterval = 60

---@type boolean if true, players can have both legal and illegal jobs simultaneously, otherwise they can only have one type of job
Config.canHaveLegalAndIllegalJob = false

---@type boolean if true, salaries will be paid from the organization's account, otherwise the money will be created out of thin air
Config.salaryFromOrganizationAccount = true

---@class Config.Job.Grade
---@field public label string the label of the grade
---@field public salary number the salary of the grade

---@class Config.Job Each job will be mapped to an organization. Jobs can be legal or illegal.
---@field public name string the unique name of the job
---@field public label string the label of the job
---@field public grades table<Config.Job.Grade> the grades of the job, starting with the lowest grade
---@field public isLegal boolean? whether the job is legal or illegal (default: true)
---@field public funding number? the amount of funding the organization should receive each day (default: 0)
---@field public paycheckAccount 'bank'|'cash'|string? the account to which the paycheck should be paid (default: "bank")

---@type table<Config.Job>
Config.jobs = {
    {
        name = "police",
        label = "Police",
        grades = {
            { label = "Officer",    salary = 100 },
            { label = "Sergeant",   salary = 200 },
            { label = "Lieutenant", salary = 300 },
            { label = "Captain",    salary = 400 },
        }
    }
}
