/**
 *
 * Sponsor List Component
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

export function SponsorList(props) {
  const { classes } = props;
  const { links } = props;

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: 'Name', field: 'sponsor_name' },
    { title: 'Title', field: 'sponsor_title' }
  ];

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.sponsorList}>
      <React.Fragment>
        <Box className={classes.floatRight}>
          <Button
            className={classes.actionButton}
            variant='contained'
            to={links.sponsorNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            NEW SPONSOR
          </Button>
        </Box>
        <Box className={classes.floatSpacer} />
        <DiverstTable
          title='Sponsors'
          handlePagination={props.handlePagination}
          isLoading={props.isFetchingSponsors}
          onOrderChange={handleOrderChange}
          dataArray={props.sponsorList}
          dataTotal={props.sponsorTotal}
          columns={columns}
          rowsPerPage={props.params.count}
          actions={[
            {
              icon: () => <EditIcon />,
              tooltip: 'Edit Member',
              onClick: (_, rowData) => {
                props.handleVisitSponsorEdit(rowData.id);
              }
            },
            {
              icon: () => <DeleteIcon />,
              tooltip: 'Delete Sponsor',
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete sponsor?'))
                  props.deleteSponsorBegin({ id: rowData.id });
              }
            }]}
        />
      </React.Fragment>
    </DiverstFormLoader>
  );
}

SponsorList.propTypes = {
  classes: PropTypes.object,
  deleteSponsorBegin: PropTypes.func,
  links: PropTypes.shape({
    sponsorNew: PropTypes.string,
  }),
  params: PropTypes.object,
  sponsorList: PropTypes.array,
  sponsorTotal: PropTypes.number,
  isFetchingSponsors: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  isFormLoading: PropTypes.bool,
  edit: PropTypes.bool,
  sponsor: PropTypes.object,
  handleVisitSponsorEdit: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(SponsorList);
