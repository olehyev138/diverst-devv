/*
 * Custom Text Messages
 *
 * This contains all the text for the Custom Text containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.GlobalSettings.Links';

export default defineMessages({
  fields: {
    id: `${scope}.tab.fields`
  },
  customTexts: {
    id: `${scope}.tab.customTexts`
  },
  configuration: {
    id: `${scope}.tab.configuration`
  },
  sso: {
    id: `${scope}.tab.sso`
  },
  emails: {
    id: `${scope}.tab.emails`
  },
});
