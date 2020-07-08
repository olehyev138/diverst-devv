/*
 * HomePage Messages
 *
 * This contains all the text for the HomePage container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.HomePage';

export default defineMessages({
  header: {
    id: `${scope}.header`,
    defaultMessage: 'This is the HomePage container!',
  },
  news: {
    id: `${scope}.news`,
  },
  events: {
    id: `${scope}.events`,
  },
  privacy: {
    id: `${scope}.privacy`,
  },
  close: {
    id: `${scope}.close`,
  },
  ok: {
    id: `${scope}.ok`,
  },
  consent: {
    id: `${scope}.consent`,
  },

});
