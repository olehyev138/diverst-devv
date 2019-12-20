/**
 *
 * Group Leaders List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupMembers/messages';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';

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

export function GroupLeadersList(props) {
  const { classes } = props;
  const { links } = props;
  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: 'GroupLeader', field: 'user.name' },
    { title: 'Position', field: 'position_name' }
  ];

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupLeaderList}>
      <React.Fragment>
        <Box className={classes.floatRight}>
          <Button
            className={classes.actionButton}
            variant='contained'
            to={links.groupLeaderNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            NEW GROUP LEADER
          </Button>
        </Box>
        <Box className={classes.floatSpacer} />
        <DiverstTable
          title='Group Leaders'
          handlePagination={props.handlePagination}
          isLoading={props.isFetchingGroupLeaders}
          onOrderChange={handleOrderChange}
          dataArray={props.groupLeaderList}
          dataTotal={props.groupLeaderTotal}
          columns={columns}
          rowsPerPage={props.params.count}
          actions={[
            {
              icon: () => <EditIcon />,
              tooltip: 'Edit Group Leader',
              onClick: (_, rowData) => {
                props.handleVisitGroupLeaderEdit(rowData.group_id, rowData.id);
              }
            },
            {
              icon: () => <DeleteIcon />,
              tooltip: 'Delete Group Leader',
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete group leader?'))
                  props.deleteGroupLeaderBegin({ group_id: rowData.group_id, id: rowData.id });
              }
            }]}
        />
      </React.Fragment>
    </DiverstFormLoader>
  );
}

GroupLeadersList.propTypes = {
  classes: PropTypes.object,
  deleteGroupLeaderBegin: PropTypes.func,
  links: PropTypes.shape({
    groupLeaderNew: PropTypes.string,
  }),
  params: PropTypes.object,
  groupLeaderList: PropTypes.array,
  groupLeaderTotal: PropTypes.number,
  isFetchingGroupLeaders: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  isFormLoading: PropTypes.bool,
  edit: PropTypes.bool,
  groupLeader: PropTypes.object,
  handleVisitGroupLeaderEdit: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupLeadersList);
