import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.App';

export default defineMessages({
  days_of_week: [
    {
      id: `${scope}.dayOfWeek.sunday`,
    },
    {
      id: `${scope}.dayOfWeek.monday`,
    },
    {
      id: `${scope}.dayOfWeek.tuesday`,
    },
    {
      id: `${scope}.dayOfWeek.wednesday`,
    },
    {
      id: `${scope}.dayOfWeek.thursday`,
    },
    {
      id: `${scope}.dayOfWeek.friday`,
    },
    {
      id: `${scope}.dayOfWeek.saturday`,
    },
  ],
  confirmation: {
    yes: {
      id: `${scope}.confirmation.yes`
    },
    no: {
      id: `${scope}.confirmation.no`
    }
  }
});
