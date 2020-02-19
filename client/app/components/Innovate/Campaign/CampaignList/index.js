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
import messages from 'containers/Innovate/Campaign/messages';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';
import CampaignQuestionsList from '../CampaignQuestion/CampaignQuestionsList';

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
  const { links } = props;

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: <DiverstFormattedMessage {...messages.Campaign.title} />, field: 'title' },
    { title: <DiverstFormattedMessage {...messages.Campaign.description} />, field: 'description' }
  ];

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.campaignList}>
      <React.Fragment>
        <Box className={classes.floatRight}>
          <Button
            className={classes.actionButton}
            variant='contained'
            to={links.campaignNew}
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
          title={<DiverstFormattedMessage {...messages.Campaign.campaigns} />}
          handlePagination={props.handlePagination}
          isLoading={props.isFetchingCampaigns}
          onOrderChange={handleOrderChange}
          handleRowClick={(_, rowData) => props.handleVisitCampaignShow(rowData.id)}
          dataArray={props.campaignList}
          dataTotal={props.campaignTotal}
          columns={columns}
          rowsPerPage={props.params.count}
          actions={[
            {
              icon: () => <EditIcon />,
              tooltip: <DiverstFormattedMessage {...messages.Campaign.edit} />,
              onClick: (_, rowData) => {
                props.handleVisitCampaignEdit(rowData.id);
              }
            },
            {
              icon: () => <DeleteIcon />,
              tooltip: <DiverstFormattedMessage {...messages.Campaign.delete} />,
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete campaign?'))
                  props.deleteCampaignBegin({ id: rowData.id });
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
  edit: PropTypes.bool,
  campaign: PropTypes.object,
  handleVisitCampaignEdit: PropTypes.func,
  handleVisitCampaignShow: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(CampaignList);
