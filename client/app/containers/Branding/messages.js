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
  },
  Sponsors: {
    sname: {
      id: `${scope}.Sponsors.input.name`,
    },
    stitle: {
      id: `${scope}.Sponsors.input.title`,
    },
    name: {
      id: `${scope}.Sponsors.list.name`,
    },
    title: {
      id: `${scope}.Sponsors.list.title`,
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
    new: {
      id: `${scope}.Sponsors.new`,
    },
  },
});
