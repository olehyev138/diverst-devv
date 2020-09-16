**Issue Code:** [DI-###]

---
### Requirements Checklist
> **Note:** Requirements are intended to be assertions, meaning that if you didn't directly change what the requirement said, checking it conveys that you verified that it wasn't necessary to make the respective changes, with the exception of items in *italics* which should only be checked if actual changes were made (this helps us be aware of potentially destructive changes)

### General
- [ ] Completed the specified task as described using proper code patterns & practices
- [ ] Provided documentation via comments & if necessary a docs/wiki entry
- [ ] Checked for and fixed lint & styling issues
- [ ] Used popular, applicable, and compatible libraries (existing or added) where relevant
- [ ] Removed any unnecessary (commented or not) code and imports
- [ ] Excluded local only, package, and build files unless necessary

#### Frontend
- [ ] Updated/added tests for all changes & they're passing
- [ ] Verified that there are no console errors
- [ ] Used translation entries for all strings
- [ ] Added all necessary conditionals for permissions
- [ ] Used pre-existing loader components coupled with Redux actions for proper UX where relevant
- [ ] Reused and/or created shared components as much as possible

#### Backend
- [ ] Updated/added tests for all changes & they're passing
- [ ] Verified that there are no server or Sidekiq errors
- [ ] Methods/actions catch, throw, and return exceptions properly & with respect to API responses
- [ ] Ensured that policies, serializers, permitted params, model validations, and controller actions enforce intended authorization
- [ ] *Updated seeds, factories, and included a proper migration (with the schema changes) when a model is changed accordingly*
