import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';
import EditIcon from '@material-ui/icons/Edit';

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

export function AnswerList(props) {
  const { classes } = props;

  const handleOrderChange = (columnId, orderDir) => {
  };

  const columns = [
    { title: 'Author', field: 'author.name' },
    { title: 'Answer', field: 'content' },
  ];

  return (
    <React.Fragment>

      <Box className={classes.floatSpacer} />
      <DiverstTable
        title='Author'
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingAnswers}
        onOrderChange={handleOrderChange}
        dataArray={props.answerList}
        dataTotal={props.answerTotal}
        columns={columns}
        rowsPerPage={props.params.count}
        actions={[ {
          icon: () => <DeleteIcon />,
          tooltip: 'Delete Answer',
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete answer?'))
              props.deleteAnswerBegin({ questionId: props.questionId, answerId: rowData.id });
          }
        }]}
      />
    </React.Fragment>
  );
}

AnswerList.propTypes = {
  classes: PropTypes.object,
  deleteAnswerBegin: PropTypes.func,
  params: PropTypes.object,
  answerList: PropTypes.array,
  answerTotal: PropTypes.number,
  isFetchingAnswers: PropTypes.bool,
  questionId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(AnswerList);
