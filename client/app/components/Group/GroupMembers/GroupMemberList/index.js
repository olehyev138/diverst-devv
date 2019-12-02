/**
 *
 * Group Member List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box, MenuItem
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupMembers/messages';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
  actionButton: {
    marginRight: 12,
    marginBottom: 12,
  },
  floatRight: {
    float: 'right',
    marginBottom: 12,
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 24,
  },
});

const MemberTypes = Object.freeze({
  active: 0,
  inactive: 1,
  pending: 2,
  all: 3,
});

export function GroupMemberList(props) {
  const { classes } = props;

  // MENU CODE
  const [anchor, setAnchor] = React.useState(null);
  const [memberType, setMemberType] = React.useState(MemberTypes.active)

  const handleClick = (event) => {
    setAnchor(event.currentTarget);
  };
  const handleClose = (type) => {
    setAnchor(null);
    setMemberType(type);
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `users.${columns[columnId].field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' }
  ];

  return (
    <React.Fragment>
      <Box className={classes.floatRight}>
        <Button
          className={classes.actionButton}
          variant='contained'
          to={props.links.groupMembersNew}
          color='primary'
          size='large'
          component={WrappedNavLink}
          startIcon={<AddIcon />}
        >
          <DiverstFormattedMessage {...messages.new} />
        </Button>
        <Button
          className={classes.actionButton}
          variant='contained'
          to='#'
          color='secondary'
          size='large'
          component={WrappedNavLink}
          startIcon={<ExportIcon />}
        >
          <DiverstFormattedMessage {...messages.export} />
        </Button>
      </Box>
      <Box className={classes.floatRight}>
        <Button onClick={handleClick}>
          {memberType}
        </Button>
      </Box>
      <Box className={classes.floatSpacer} />
      <DiverstTable
        title='Members'
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingMembers}
        onOrderChange={handleOrderChange}
        dataArray={props.memberList}
        dataTotal={props.memberTotal}
        columns={columns}
        rowsPerPage={props.params.count}
        actions={[{
          icon: () => <DeleteIcon />,
          tooltip: 'Delete Member',
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete member?'))
              props.deleteMemberBegin({
                userId: rowData.id,
                groupId: props.groupId
              });
          }
        }]}
      />
      <DiverstDropdownMenu
        anchor={anchor}
        setAnchor={setAnchor}
      >
        <MenuItem onClick={() => handleClose(MemberTypes.active)}>
          Active
        </MenuItem>
        <MenuItem onClick={() => handleClose(MemberTypes.inactive)}>
          Inactive
        </MenuItem>
        <MenuItem onClick={() => handleClose(MemberTypes.pending)}>
          Pending
        </MenuItem>
        <MenuItem onClick={() => handleClose(MemberTypes.all)}>
          All
        </MenuItem>
      </DiverstDropdownMenu>
    </React.Fragment>
  );
}

GroupMemberList.propTypes = {
  classes: PropTypes.object,
  deleteMemberBegin: PropTypes.func,
  links: PropTypes.shape({
    groupMembersNew: PropTypes.string,
  }),
  params: PropTypes.object,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool,
  groupId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMemberList);
