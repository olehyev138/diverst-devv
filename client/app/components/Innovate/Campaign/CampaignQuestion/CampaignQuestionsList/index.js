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

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: <DiverstFormattedMessage {...messages.question.list.title} />, field: 'title' },
    { title: <DiverstFormattedMessage {...messages.question.list.description} />, field: 'description' }
  ];

  return (
    <React.Fragment>
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
      <Box className={classes.floatSpacer} />
      <DiverstTable
        title={<DiverstFormattedMessage {...messages.question.list.questions} />}
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingQuestions}
        onOrderChange={handleOrderChange}
        handleRowClick={(_, rowData) => props.handleVisitQuestionShow(props.campaignId, rowData.id)}
        dataArray={props.questionList}
        dataTotal={props.questionTotal}
        columns={columns}
        rowsPerPage={props.params.count}
        actions={[{
          icon: () => <EditIcon />,
          tooltip: <DiverstFormattedMessage {...messages.question.edit} />,
          onClick: (_, rowData) => {
            props.handleVisitQuestionEdit(props.campaignId, rowData.id);
          }
        }, {
          icon: () => <DeleteIcon />,
          tooltip: <DiverstFormattedMessage {...messages.question.delete} />,
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete question?'))
              props.deleteQuestionBegin({ campaignId: props.campaignId, questionId: rowData.id });
          }
        }]}
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
  questionTotal: PropTypes.number,
  isFetchingQuestions: PropTypes.bool,
  campaignId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitQuestionEdit: PropTypes.func,
  handleVisitQuestionShow: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(CampaignQuestionsList);
