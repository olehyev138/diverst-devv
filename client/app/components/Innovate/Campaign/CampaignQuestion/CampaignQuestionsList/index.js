/**
 *
 * Campaign Question List Component
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

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';
import EditIcon from '@material-ui/icons/Edit';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Innovate/Campaign/CampaignQuestion/messages';
import { permission } from 'utils/permissionsHelpers';
import Permission from 'components/Shared/DiverstPermission';
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

export function CampaignQuestionsList(props) {
  const { classes } = props;
  const { links } = props;
  const { intl } = props;

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: intl.formatMessage(messages.question.list.title, props.customTexts), field: 'title' },
    { title: intl.formatMessage(messages.question.list.description, props.customTexts), field: 'description' }
  ];

  return (
    <React.Fragment>
      <Permission show={permission(props.campaign, 'update?')}>
        <Box className={classes.floatRight}>
          <Button
            className={classes.actionButton}
            variant='contained'
            to={props.links.campaignQuestionNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            ADD NEW QUESTION
          </Button>
        </Box>
      </Permission>
      <Box className={classes.floatSpacer} />
      <DiverstTable
        title={messages.question.list.questions}
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingQuestions}
        onOrderChange={handleOrderChange}
        handleRowClick={(_, rowData) => props.handleVisitQuestionShow(props.campaignId, rowData.id)}
        dataArray={props.questionList}
        dataTotal={props.questionTotal}
        columns={columns}
        rowsPerPage={props.params.count}
        actions={[
          rowData => ({
            icon: () => <EditIcon />,
            tooltip: intl.formatMessage(messages.question.edit, props.customTexts),
            onClick: (_, rowData) => {
              props.handleVisitQuestionEdit(props.campaignId, rowData.id);
            },
            disabled: !permission(rowData, 'update?')
          }),
          rowData => ({
            icon: () => <DeleteIcon />,
            tooltip: intl.formatMessage(messages.question.delete, props.customTexts),
            onClick: (_, rowData) => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              if (confirm(intl.formatMessage(messages.deleteQuestionConfirm, props.customTexts)))
                props.deleteQuestionBegin({ campaignId: props.campaignId, questionId: rowData.id });
            },
            disabled: !permission(rowData, 'destroy?')
          })
        ]}
      />
    </React.Fragment>
  );
}

CampaignQuestionsList.propTypes = {
  classes: PropTypes.object,
  deleteQuestionBegin: PropTypes.func,
  links: PropTypes.shape({
    campaignQuestionNew: PropTypes.string,
  }),
  params: PropTypes.object,
  questionList: PropTypes.array,
  campaign: PropTypes.object,
  questionTotal: PropTypes.number,
  isFetchingQuestions: PropTypes.bool,
  campaignId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitQuestionEdit: PropTypes.func,
  handleVisitQuestionShow: PropTypes.func,
  intl: intlShape.isRequired,
  customTexts: PropTypes.object,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(CampaignQuestionsList);
