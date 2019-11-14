/**
 *
 * Campaign List Component
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

export function CampaignList(props) {
  const { classes } = props;

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: 'Title', field: 'title' },
    { title: 'Description', field: 'description' }
  ];

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.campaigns}>
      <React.Fragment>
        <Box className={classes.floatRight}>
          <Button
            className={classes.actionButton}
            variant='contained'
            to='campaigns/new'
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            NEW CAMPAIGN
          </Button>
        </Box>
        <Box className={classes.floatSpacer} />
        <DiverstTable
          title='Campaigns'
          handlePagination={props.handlePagination}
          isLoading={props.isFetchingCampaigns}
          onOrderChange={handleOrderChange}
          dataArray={props.campaignList}
          dataTotal={props.campaignTotal}
          columns={columns}
          rowsPerPage={props.params.count}
          actions={[{
            icon: () => <DeleteIcon />,
            tooltip: 'Delete Member',
            onClick: (_, rowData) => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              if (confirm('Delete campaign?'))
                props.deleteCampaignBegin({
                  userId: rowData.id,
                });
            }
          }]}
        />
      </React.Fragment>
    </DiverstFormLoader>
  );
}

CampaignList.propTypes = {
  classes: PropTypes.object,
  deleteCampaignBegin: PropTypes.func,
  links: PropTypes.shape({
    campaignNew: PropTypes.string,
  }),
  params: PropTypes.object,
  campaignList: PropTypes.array,
  campaignTotal: PropTypes.number,
  isFetchingCampaigns: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  isFormLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(CampaignList);
