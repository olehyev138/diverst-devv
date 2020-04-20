/**
 *
 * UserList Component
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
  Typography, Grid, Link, TablePagination, Collapse, Box, MenuItem,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';
import { injectIntl, intlShape } from 'react-intl';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  userListItem: {
    width: '100%',
  },
  userListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function UserList(props, context) {
  const { classes, intl } = props;
  const [expandedUsers, setExpandedUsers] = useState({});

  const [userForm, setUserForm] = useState(undefined);

  const [anchor, setAnchor] = React.useState(null);

  const handleClick = (event) => {
    setAnchor(event.currentTarget);
  };

  const handleClose = (type) => {
    setAnchor(null);
    props.handleChangeScope(type);
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: <DiverstFormattedMessage {...messages.first_name} />,
      field: 'first_name',
      query_field: 'first_name'
    },
    {
      title: <DiverstFormattedMessage {...messages.last_name} />,
      field: 'last_name',
      query_field: 'last_name'
    },
    {
      title: <DiverstFormattedMessage {...messages.email} />,
      field: 'email',
      query_field: 'email'
    },
  ];

  return (
    <React.Fragment>
      <Grid container>
        <Grid item md={6}>
          <Button
            variant='contained'
            color='secondary'
            size='large'
            onClick={handleClick}
          >
            <DiverstFormattedMessage {...messages.scopes[props.userType]} />
          </Button>
        </Grid>
        <Grid item md={6}>
          <Grid container spacing={3} justify='flex-end'>
            <Grid item>
              <Button
                variant='contained'
                color='primary'
                size='large'
                to={props.links.userNew}
                component={WrappedNavLink}
                startIcon={<AddIcon />}
              >
                <DiverstFormattedMessage {...messages.new} />
              </Button>
            </Grid>
          </Grid>
        </Grid>
      </Grid>

      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={intl.formatMessage(messages.members)}
            handlePagination={props.handlePagination}
            handleOrdering={props.handleOrdering}
            isLoading={props.isFetchingUsers}
            rowsPerPage={5}
            dataArray={Object.values(props.users)}
            dataTotal={props.userTotal}
            columns={columns}
            actions={[
              rowData => ({
                icon: () => <EditIcon />,
                tooltip: intl.formatMessage(messages.tooltip.edit),
                onClick: (_, rowData) => {
                  props.handleVisitUserEdit(rowData.id);
                },
                disabled: !permission(rowData, 'update?')
              }),
              rowData => ({
                icon: () => <DeleteIcon />,
                tooltip: intl.formatMessage(messages.tooltip.delete),
                onClick: (_, rowData) => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  if (confirm(intl.formatMessage(messages.delete_confirm)))
                    props.deleteUserBegin(rowData.id);
                },
                disabled: !permission(rowData, 'destroy?')
              })
            ]}
            my_options={{
              exportButton: true,
              exportCsv: (columns, data) => {
                props.exportUsers();
              }
            }}
          />
        </Grid>
      </Grid>
      <DiverstDropdownMenu
        anchor={anchor}
        setAnchor={setAnchor}
      >
        <MenuItem
          onClick={() => handleClose('all')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.all} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('inactive')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.inactive} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('invitation_sent')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.invitation_sent} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('saml')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.saml} />
        </MenuItem>
      </DiverstDropdownMenu>
    </React.Fragment>
  );
}

UserList.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  users: PropTypes.object,
  userTotal: PropTypes.number,
  isFetchingUsers: PropTypes.bool,
  deleteUserBegin: PropTypes.func,
  exportUsers: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitUserEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  userType: PropTypes.string,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  })
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(UserList);
