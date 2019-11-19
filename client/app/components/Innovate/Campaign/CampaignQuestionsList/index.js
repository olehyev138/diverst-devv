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

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupMembers/messages';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';
import EditIcon from '@material-ui/core/SvgIcon/SvgIcon';

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
    { title: 'Questions', field: 'questions' },
    { title: '# of answers', field: 'answers' }
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
      <Box className={classes.floatSpacer} />
      <DiverstTable
        title='Questions'
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingQuestions}
        onOrderChange={handleOrderChange}
        dataArray={props.questionList}
        dataTotal={props.questionTotal}
        columns={columns}
        rowsPerPage={props.params.count}
        actions={[{
          icon: () => <EditIcon />,
          tooltip: 'Edit Member',
          onClick: (_, rowData) => {
            props.handleVisitQuestionEdit(rowData.id);
          }
        }, {
          icon: () => <DeleteIcon />,
          tooltip: 'Delete Question',
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete question?'))
              props.deleteQuestionBegin({ id: rowData.id });
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
};

export default compose(
  memo,
  withStyles(styles)
)(CampaignQuestionsList);
