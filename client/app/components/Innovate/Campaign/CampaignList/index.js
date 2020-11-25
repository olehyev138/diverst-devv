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
import { injectIntl, intlShape } from 'react-intl';
import { permission } from 'utils/permissionsHelpers';

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
  const { links, intl } = props;

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: intl.formatMessage(messages.Campaign.title, props.customTexts), field: 'title' },
    { title: intl.formatMessage(messages.Campaign.description, props.customTexts), field: 'description' }
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
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Box>
        <Box className={classes.floatSpacer} />
        <DiverstTable
          title={messages.Campaign.campaigns}
          handlePagination={props.handlePagination}
          isLoading={props.isFetchingCampaigns}
          onOrderChange={handleOrderChange}
          handleRowClick={(_, rowData) => props.handleVisitCampaignShow(rowData.id)}
          dataArray={props.campaignList}
          dataTotal={props.campaignTotal}
          columns={columns}
          rowsPerPage={props.params.count}
          actions={[
            rowData => ({
              icon: () => <EditIcon />,
              tooltip: intl.formatMessage(messages.Campaign.edit, props.customTexts),
              onClick: (_, rowData) => {
                props.handleVisitCampaignEdit(rowData.id);
              },
              disabled: !permission(rowData, 'update?')
            }),
            rowData => ({
              icon: () => <DeleteIcon />,
              tooltip: intl.formatMessage(messages.Campaign.delete, props.customTexts),
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm(intl.formatMessage(messages.Campaign.delete_confirm, props.customTexts)))
                  props.deleteCampaignBegin({ id: rowData.id });
              },
              disabled: !permission(rowData, 'update?')
            })
          ]}
        />
      </React.Fragment>
    </DiverstFormLoader>
  );
}

CampaignList.propTypes = {
  classes: PropTypes.object,
  intl: intlShape.isRequired,
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
  customTexts: PropTypes.object
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(CampaignList);
