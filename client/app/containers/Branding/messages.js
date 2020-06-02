/*
 * Branding Messages
 *
 * This contains all the text for the Branding containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Branding';

export default defineMessages({
  create: {
    id: `${scope}.form.button.create`,
  },
  update: {
    id: `${scope}.form.button.edit`,
  },
  save: {
    id: `${scope}.form.button.save`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  tabs: {
    home: {
      id: `${scope}.tab.home`,
    },
    theme: {
      id: `${scope}.tab.theme`,
    },
    sponsors: {
      id: `${scope}.tab.sponsors`,
    },
  },
  Theme: {
    colorswitch: {
      id: `${scope}.Theme.input.colorswitch`,
    },
    primarycolor: {
      id: `${scope}.Theme.input.primarycolor`,
    },
    graphcolor: {
      id: `${scope}.Theme.input.graphcolor`,
    },
    logo: {
      id: `${scope}.Theme.input.logo`,
    },
    url: {
      id: `${scope}.Theme.input.url`,
    },
  },
  Home: {
    message: {
      id: `${scope}.Home.input.message`,
    },
    privacy: {
      id: `${scope}.Home.input.privacy`,
    },
  },
  Sponsors: {
    name: {
      id: `${scope}.Sponsors.input.name`,
    },
    title: {
      id: `${scope}.Sponsors.input.title`,
    },
    message: {
      id: `${scope}.Sponsors.input.message`,
    },
    media: {
      id: `${scope}.Sponsors.input.media`,
    },
    tabletitle: {
      id: `${scope}.Sponsors.table.title`,
    },
    edit: {
      id: `${scope}.Sponsors.tooltip.edit`,
    },
    delete: {
      id: `${scope}.Sponsors.tooltip.delete`,
    },
    delete_confirm: {
      id: `${scope}.Sponsors.tooltip.delete_confirm`,
    },
    new: {
      id: `${scope}.Sponsors.new`,
    },
  },
});
