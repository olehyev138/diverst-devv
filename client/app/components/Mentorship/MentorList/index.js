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
  Typography, Grid, Link, TablePagination, Collapse, Box, Paper, Tab,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';
import AssignmentIndIcon from '@material-ui/icons/AssignmentInd';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstPagination from 'components/Shared/DiverstPagination';
import { customTexts } from '../../../utils/customTextHelpers';
import ResponsiveTabs from '../../Shared/ResponsiveTabs';


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
  const { type } = props;

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' },
    { title: 'Email', field: 'email' },
    { title: 'Interests', field: 'interests' },
  ];

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label='Current' />
          <Tab label='Available' />
          {/* <Tab label={intl.formatMessage(messages.index.ongoing, customTexts())} /> */}
        </ResponsiveTabs>
      </Paper>
      <Box mb={1} />
      <DiverstTable
        title={`${props.currentTab === 0 ? 'Your' : 'Available'} ${type.charAt(0).toUpperCase() + type.slice(1)}`}
        handlePagination={props.handleMentorPagination}
        handleOrdering={props.handleMentorOrdering}
        isLoading={props.isFetchingUsers}
        rowsPerPage={5}
        params={props.params}
        dataArray={props.users}
        dataTotal={props.userTotal}
        columns={columns}
        actions={[{
          icon: () => props.currentTab === 0 ? (<DeleteIcon />) : (<AssignmentIndIcon />),
          tooltip: props.currentTab === 0 ? 'Remove' : 'Send Request',
          onClick: (_, rowData) => {
            switch (props.currentTab) {
              case 0:
                if (confirm('Delete member?'))
                  props.deleteMemberBegin({
                    userId: rowData.id,
                    groupId: props.groupId
                  });
                break;
              case 1:
                break;
              default:
                break;
            }
          }
        }]}
      />
    </React.Fragment>
  );
}

UserList.propTypes = {
  type: PropTypes.string,
  classes: PropTypes.object,
  users: PropTypes.array,
  userTotal: PropTypes.number,
  isFetchingUsers: PropTypes.bool,
  availableUsers: PropTypes.array,
  availableUserTotal: PropTypes.number,
  isFetchingAvailableUsers: PropTypes.bool,
  userParams: PropTypes.object,
  handleMentorPagination: PropTypes.func,
  handleMentorOrdering: PropTypes.func,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  params: PropTypes.object,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(UserList);
