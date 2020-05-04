/*
 * LocaleToggle Messages
 *
 * This contains all the text for the LanguageToggle component.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.LocaleToggle';

export default defineMessages({
  language: {
    id: `${scope}.language`
  },
  locales: {
    en: {
      id: `${scope}.locales.en`,
    },
    es: {
      id: `${scope}.locales.es`,
    },
    fr: {
      id: `${scope}.locales.fr`,
    },
  },
});
