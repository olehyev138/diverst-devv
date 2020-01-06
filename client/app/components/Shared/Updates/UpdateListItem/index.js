/**
 *
 * Field Component
 *
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Collapse, Box, Hidden
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/Field/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import FieldForm from 'components/Shared/Fields/FieldForms/FieldForm';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import {DateTime, formatDateTimeString} from "../../../../utils/dateTimeHelpers";
import KeyboardArrowRightIcon from "@material-ui/icons/KeyboardArrowRight";

const styles = theme => ({
  fieldListItem: {
    width: '100%',
  },
  fieldListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  fieldTitleButton: {
    textTransform: 'none',
  },
  fieldFormCollapse: {
    width: '100%',
  },
  fieldFormContainer: {
    width: '100%',
    padding: theme.spacing(1.5),
  },
});

export function FieldList(props, context) {
  const { classes, ...rest } = props;

  const { update } = props;

  const [form, setForm] = useState(false);

  return (
    <Grid container spacing={1} justify='space-between' alignItems='center'>
      <Grid item xs>
        <Typography color='primary' variant='h6' component='h2'>
          {formatDateTimeString(update.report_date, DateTime.DATE_MED)}
        </Typography>
        <hr className={classes.divider} />
        {update.comments && (
          <React.Fragment>
            <Typography color='textSecondary'>
              {update.comments}
            </Typography>
            <Box pb={1} />
          </React.Fragment>
        )}
      </Grid>
    </Grid>
  );
}

FieldList.propTypes = {
  classes: PropTypes.object,
  update: PropTypes.object,
  isLoading: PropTypes.bool,
  updateFieldBegin: PropTypes.func,
  deleteFieldBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(FieldList);
