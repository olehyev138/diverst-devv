/**
 *
 * UserRoleList Component
 *
 *
 */

import React, {
  memo, useEffect, useRef, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/UserRole/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { injectIntl, intlShape } from 'react-intl';

import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';
import { permission } from 'utils/permissionsHelpers';
import Permission from 'components/Shared/DiverstPermission';

const styles = theme => ({
  userRoleListItem: {
    width: '100%',
  },
  userListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function UserRoleList(props, context) {
  const { classes, links, intl } = props;

  const columns = [
    { title: intl.formatMessage(messages.role_name, props.customTexts), field: 'role_name' },
    { title: intl.formatMessage(messages.role_type, props.customTexts), field: 'role_type' },
    { title: intl.formatMessage(messages.priority, props.customTexts), field: 'priority' },
  ];

  return (
    <React.Fragment>
      <Permission show={permission(props, 'policy_templates_create')}>
        <Grid container spacing={3} justify='flex-end'>
          <Grid item>
            <Button
              variant='contained'
              color='primary'
              size='large'
              to={links.userRoleNew}
              component={WrappedNavLink}
              startIcon={<AddIcon />}
            >
              <DiverstFormattedMessage {...messages.new} />
            </Button>
          </Grid>
        </Grid>
      </Permission>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={messages.title}
            handlePagination={props.handlePagination}
            handleOrdering={props.handleOrdering}
            isLoading={props.isFetchingUserRoles}
            rowsPerPage={5}
            dataArray={Object.values(props.userRoles)}
            dataTotal={props.userRoleTotal}
            columns={columns}
            actions={[
              rowData => ({
                icon: () => <EditIcon />,
                tooltip: intl.formatMessage(messages.edit, props.customTexts),
                onClick: (_, rowData) => {
                  props.handleVisitUserRoleEdit(rowData.id);
                },
                disabled: !permission(rowData, 'update?')
              }),
              rowData => ({
                icon: () => <DeleteIcon />,
                tooltip: (() => {
                  if (rowData.default)
                    return intl.formatMessage(messages.delete_default_role, props.customTexts);
                  if (!permission(rowData, 'destroy?') && rowData.role_type === 'group')
                    return intl.formatMessage(messages.delete_group_in_use, props.customTexts);
                  return intl.formatMessage(messages.delete, props.customTexts);
                })(),
                onClick: (_, rowData) => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  if (confirm(intl.formatMessage(messages.delete_confirm, props.customTexts)))
                    props.deleteUserRoleBegin(rowData.id);
                },
                disabled: !permission(rowData, 'destroy?')
              })
            ]}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

UserRoleList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  userRoles: PropTypes.object,
  userRoleTotal: PropTypes.number,
  isFetchingUserRoles: PropTypes.bool,
  deleteUserRoleBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitUserRoleEdit: PropTypes.func,
  links: PropTypes.shape({
    userRoleNew: PropTypes.string,
    userRoleEdit: PropTypes.func
  }),
  customTexts: PropTypes.object,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(UserRoleList);
