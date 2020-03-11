/*
 * App Messages
 *
 * This contains all the custom text messages
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.App';

export default defineMessages({
  texts: {
    erg: {
      id: `${scope}.texts.erg`,
    },
    program: {
      id: `${scope}.texts.program`,
    },
    structure: {
      id: `${scope}.texts.structure`,
    },
    outcome: {
      id: `${scope}.texts.outcome`,
    },
    badge: {
      id: `${scope}.texts.badge`,
    },
    segment: {
      id: `${scope}.texts.segment`,
    },
    dci_full_title: {
      id: `${scope}.texts.dci_full_title`,
    },
    dci_abbreviation: {
      id: `${scope}.texts.dci_abbreviation`,
    },
    member_preference: {
      id: `${scope}.texts.member_preference`,
    },
    parent: {
      id: `${scope}.texts.parent`,
    },
    sub_erg: {
      id: `${scope}.texts.sub_erg`,
    },
    privacy_statement: {
      id: `${scope}.texts.privacy_statement`,
    },
  },
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
  },
  currency: {
    placement: {
      id: `${scope}.currency.placement`
    },
    symbol: {
      id: `${scope}.currency.symbol`
    },
    defaultSymbol: {
      id: `${scope}.currency.defaultSymbol`
    }
  },
  person: {
    givenName: {
      id: `${scope}.person.givenName`
    },
    familyName: {
      id: `${scope}.person.familyName`
    },
    email: {
      id: `${scope}.person.email`
    }
  },
  header: {
    dashboard: {
      id: `${scope}.header.dashboard`
    },
    admin: {
      id: `${scope}.header.admin`
    },
    profile: {
      id: `${scope}.header.profile`
    },
    logout: {
      id: `${scope}.header.logout`
    },
  }
});