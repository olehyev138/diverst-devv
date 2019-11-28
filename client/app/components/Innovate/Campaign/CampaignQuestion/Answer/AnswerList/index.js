import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box, Card, CardContent, Grid
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import AnswerListItem from 'components/Innovate/Campaign/CampaignQuestion/Answer/AnswerListItem';

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
  return (
    <React.Fragment>
      {props.answerList && props.answerList.map((answer, i) => (
        <AnswerListItem
          currentAnswer={answer}
          key={answer.id}
        />
      ))}
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
