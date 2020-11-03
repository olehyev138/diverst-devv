/**
 *
 * Region Leaders List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { Box, Button, Grid } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Region/RegionLeaders/messages';
import DiverstTable from 'components/Shared/DiverstTable';
import { injectIntl, intlShape } from 'react-intl';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function RegionLeadersList(props) {
  const { classes, links, intl } = props;

  const columns = [
    { title: intl.formatMessage(messages.table.column_name), field: 'user.name', query_field: 'users.last_name' },
    { title: intl.formatMessage(messages.table.column_position), field: 'position_name', query_field: 'position_name' }
  ];

  const actions = [];
  if (permission(props.region, 'leaders_manage?')) {
    actions.push({
      icon: () => <EditIcon />,
      tooltip: intl.formatMessage(messages.edit),
      onClick: (_, rowData) => {
        props.handleVisitRegionLeaderEdit(rowData.leader_of_id, rowData.id);
      }
    });
    actions.push({
      icon: () => <DeleteIcon />,
      tooltip: intl.formatMessage(messages.delete),
      onClick: (_, rowData) => {
        /* eslint-disable-next-line no-alert, no-restricted-globals */
        if (confirm('Are you sure you want to delete this region leader?'))
          props.deleteRegionLeaderBegin({ region_id: rowData.leader_of_id, id: rowData.id });
      }
    });
  }

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'region_leaders.id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      <Permission show={permission(props.region, 'leaders_create?')}>
        <Grid container spacing={3} justify='flex-end'>
          <Grid item>
            <Button
              variant='contained'
              to={links.regionLeaderNew}
              color='primary'
              size='large'
              component={WrappedNavLink}
              startIcon={<AddIcon />}
            >
              {<DiverstFormattedMessage {...messages.new} />}
            </Button>
          </Grid>
        </Grid>
      </Permission>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={intl.formatMessage(messages.table.title)}
            onOrderChange={handleOrderChange}
            handlePagination={props.handlePagination}
            isLoading={props.isFetchingRegionLeaders}
            dataArray={props.regionLeaderList}
            dataTotal={props.regionLeaderTotal}
            columns={columns}
            rowsPerPage={props.params.count}
            actions={actions}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

RegionLeadersList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  region: PropTypes.object,
  deleteRegionLeaderBegin: PropTypes.func,
  links: PropTypes.shape({
    regionLeaderNew: PropTypes.string,
  }),
  params: PropTypes.object,
  regionLeaderList: PropTypes.array,
  regionLeaderTotal: PropTypes.number,
  isFetchingRegionLeaders: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  isFormLoading: PropTypes.bool,
  edit: PropTypes.bool,
  regionLeader: PropTypes.object,
  handleVisitRegionLeaderEdit: PropTypes.func,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(RegionLeadersList);
