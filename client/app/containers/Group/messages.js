/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Group';
export const snackbar = 'diverst.snackbars.Group';

export default defineMessages({
  new: {
    id: `${scope}.index.button.new`,
  },
  edit: {
    id: `${scope}.index.button.edit`,
  },
  setAnnualBudget: {
    id: `${scope}.index.button.setAnnualBudget`,
  },
  delete: {
    id: `${scope}.index.button.delete`,
  },
  delete_confirm: {
    id: `${scope}.index.button.delete_confirm`,
  },
  change_order: {
    id: `${scope}.index.button.change_order`,
  },
  set_order: {
    id: `${scope}.index.button.set_order`,
  },
  children_collapse: {
    id: `${scope}.index.button.children_collapse`,
  },
  sub_erg: {
    id: `${scope}.home.sub_erg`,
  },
  groupParent: {
    id: `${scope}.home.parent`,
  },
  children_expand: {
    id: `${scope}.index.button.children_expand`,
  },
  manage_regions: {
    id: `${scope}.index.button.manage_regions`
  },
  rows: {
    id: `${scope}.index.button.rows`,
  },
  page: {
    id: `${scope}.index.button.page`,
  },
  create: {
    id: `${scope}.form.button.create`,
  },
  update: {
    id: `${scope}.form.button.update`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  name: {
    id: `${scope}.form.input.name`,
  },
  private: {
    id: `${scope}.form.input.private`,
  },
  short_description: {
    id: `${scope}.form.input.short_description`,
  },
  description: {
    id: `${scope}.form.input.description`,
  },
  children: {
    id: `${scope}.form.input.children`,
  },
  parent: {
    id: `${scope}.form.input.parent`,
  },
  settings_save: {
    id: `${scope}.settings.form.button.save`
  },
  welcome: {
    id: `${scope}.home.span.welcome`,
  },
  categorize_subgroups: {
    id: `${scope}.categorize`,
  },
  allcategories: {
    id: `${scope}.categorize.button.allcategories`,
  },
  categorize: {
    id: `${scope}.categorize.button.categorize`,
  },
  save: {
    id: `${scope}.categorize.button.save`,
  },
  family: {
    showMore: {
      id: `${scope}.family.showMore`,
    },
    showLess: {
      id: `${scope}.family.showLess`,
    },
    areMember: {
      id: `${scope}.family.areMember`,
    },
    notMember: {
      id: `${scope}.family.notMember`,
    }
  },
  join: {
    id: `${scope}.index.button.join`,
  },
  leave: {
    id: `${scope}.index.button.leave`,
  },
  yes: {
    id: `${scope}.index.button.yes`,
  },
  no: {
    id: `${scope}.index.button.no`,
  },
  thanks: {
    id: `${scope}.index.message.thanks`,
  },
  joinParent: {
    id: `${scope}.index.message.joinParent`,
  },
  joinSubgroups: {
    id: `${scope}.index.message.joinSubgroups`,
  },
  myGroups: {
    id: `${scope}.index.button.my_groups`
  },
  allGroups: {
    id: `${scope}.index.button.all_groups`
  },
  back: {
    id: `${scope}.index.button.back`
  },
  childList: {
    id: `${scope}.index.child_list`
  },
  selectorDialog: {
    title: {
      id: `${scope}.selectorDialog.title`,
    },
    subTitle: {
      id: `${scope}.selectorDialog.subTitle`,
    },
    select: {
      id: `${scope}.selectorDialog.select`,
    },
    search: {
      id: `${scope}.selectorDialog.search`,
    },
    searchPlaceholder: {
      id: `${scope}.selectorDialog.searchPlaceholder`,
    },
    save: {
      id: `${scope}.selectorDialog.save`,
    },
    clear: {
      id: `${scope}.selectorDialog.clear`,
      confirm: {
        id: `${scope}.selectorDialog.clear.confirm`,
      },
    },
    close: {
      id: `${scope}.selectorDialog.close`,
    },
    empty: {
      id: `${scope}.selectorDialog.empty`,
    },
  },
  categorizeCollapsable: {
    id: `${scope}.categorize.button.collapsable`,
  },
  snackbars: {
    errors: {
      group: {
        id: `${snackbar}.errors.group`
      },
      groups: {
        id: `${snackbar}.errors.groups`
      },
      annualBudgets: {
        id: `${snackbar}.errors.annualBudgets`
      },
      colors: {
        id: `${snackbar}.errors.colors`
      },
      create: {
        id: `${snackbar}.errors.create.group`
      },
      delete: {
        id: `${snackbar}.errors.delete.group`
      },
      update: {
        id: `${snackbar}.errors.update.group`
      },
      group_categorize: {
        id: `${snackbar}.errors.group_categorize`
      },
      update_group_position: {
        id: `${snackbar}.errors.update_group_position`
      },
      update_group_settings: {
        id: `${snackbar}.errors.update_group_settings`
      },
      carry: {
        id: `${snackbar}.errors.budget.carry`
      },
      reset: {
        id: `${snackbar}.errors.budget.reset`
      },
      leave: {
        id: `${snackbar}.errors.group.leave`
      },
      join: {
        id: `${snackbar}.errors.group.join`
      },
      join_subgroups: {
        id: `${snackbar}.errors.group.join_subgroups`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.group`
      },
      delete: {
        id: `${snackbar}.success.delete.group`
      },
      update: {
        id: `${snackbar}.success.update.group`
      },
      group_categorize: {
        id: `${snackbar}.success.group_categorize`
      },
      update_group_position: {
        id: `${snackbar}.success.update_group_position`
      },
      update_group_settings: {
        id: `${snackbar}.success.update_group_settings`
      },
      carry: {
        id: `${snackbar}.success.budget.carry`
      },
      reset: {
        id: `${snackbar}.success.budget.reset`
      },
    }
  }
});
