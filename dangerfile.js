import {message, danger} from 'danger'

/* Check for Jira issue link */
if (! danger.github.pr.body.includes("jira"))
    warn('Missing Issue Link!')

/* Ensure gemfile lock is committed when gemfile is changed */
const gemfileChanged = danger.git.modified_files.includes('Gemfile');
const gemlockfileChanged = danger.git.modified_files.includes('Gemfile.lock');
if (gemfileChanged && !gemlockfileChanged) {
    const message = 'Changes were made to Gemfile, but not to Gemfile.lock';
    const idea = 'Perhaps you need to run `bundle install`?';
    warn(`${message} - <i>${idea}</i>`);
}

/* Ensure package lock is committed when package.json is changed */
const packageChanged = danger.git.modified_files.includes('package.json');
const lockfileChanged = danger.git.modified_files.includes('package-lock.json');
if (packageChanged && !lockfileChanged) {
    const message = 'Changes were made to package.json, but not to package-lock.json';
    const idea = 'Perhaps you need to run `npm install`?';
    warn(`${message} - <i>${idea}</i>`);
}

/* Ensure schema is committed if migrations are added */
const migrations = danger.git.fileMatch("db/migrations/*.rb")
const schemaChanged = danger.git.modified_files.includes('schema.rb')
if (migrations.modified && !schemaChanged)
    warn('Migrations have been added but schema was not changed')

/* Ensure .env file is not committed */
const clientenvChanged = danger.git.modified_files.includes('.env');
if (clientenvChanged)
    warn('.env should not be committed')

