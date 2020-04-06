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

import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Branding/messages';
import { injectIntl, intlShape } from 'react-intl';

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
  const { intl } = props;

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: intl.formatMessage(messages.Sponsors.name), field: 'sponsor_name' },
    { title: intl.formatMessage(messages.Sponsors.title), field: 'sponsor_title' }
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
            <DiverstFormattedMessage {...messages.Sponsors.new} />
          </Button>
        </Box>
        <Box className={classes.floatSpacer} />
        <DiverstTable
          title={intl.formatMessage(messages.Sponsors.tabletitle)}
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
              tooltip: intl.formatMessage(messages.Sponsors.edit),
              onClick: (_, rowData) => {
                props.handleVisitSponsorEdit(rowData.sponsorable_id,rowData.id);
              }
            },
            {
              icon: () => <DeleteIcon />,
              tooltip: intl.formatMessage(messages.Sponsors.delete),
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm(intl.formatMessage(messages.Sponsors.delete_confirm)))
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
  intl: intlShape,
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
  injectIntl,
  withStyles(styles)
)(SponsorList);
