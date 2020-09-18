import {message, danger} from 'danger'

if (!github.pr_body.include("jira"))
    warn('Missing Jira Issue Link!')


