/**
 *
 * Update Component
 *
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Collapse, Box, Hidden, Link, CardActionArea, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/Update/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';


import {DateTime, formatDateTimeString} from "utils/dateTimeHelpers";
import {ROUTES} from "containers/Shared/Routes/constants";
import classNames from "classnames";


const styles = theme => ({
  updateListItem: {
    width: '100%',
  },
  updateListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  updateTitleButton: {
    textTransform: 'none',
  },
  updateFormCollapse: {
    width: '100%',
  },
  updateFormContainer: {
    width: '100%',
    padding: theme.spacing(1.5),
  },
  deleteButton: {
    color: theme.palette.error.main,
  },
});

export function UpdateList(props, context) {
  const { classes, ...rest } = props;

  const { update } = props;

  const [form, setForm] = useState(false);

  return (
    <Card>
      {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
      <CardContent>
        <Grid container spacing={1} justify='space-between' alignItems='center'>
          <Grid item xs>
            <Link
              className={classes.eventLink}
              component={WrappedNavLink}
              to={{
                pathname: props.links.show(update.id),
                state: { update }
              }}
            >
              <Typography color='primary' variant='h6' component='h2'>
                {formatDateTimeString(update.report_date, DateTime.DATE_MED) + (update.comments ? `: ${update.short_comment}` : '')}
              </Typography>
            </Link>
          </Grid>
        </Grid>
      </CardContent>
      <Divider />
      <CardActions>
        <Button
          color='primary'
          className={classes.folderLink}
          component={WrappedNavLink}
          to={{
            pathname: props.links.edit(update.id),
            update
          }}
        >
          <DiverstFormattedMessage {...(messages.edit)} />
        </Button>
        <Button
          className={classNames(classes.folderLink, classes.deleteButton)}
          onClick={() => {
            // eslint-disable-next-line no-restricted-globals
            if (confirm('DELETE? TODO'))
              props.deleteUpdateBegin(update.id);
          }}
        >
          <DiverstFormattedMessage {...(messages.delete)} />
        </Button>
      </CardActions>
    </Card>

  );
}

UpdateList.propTypes = {
  classes: PropTypes.object,
  update: PropTypes.object,
  isLoading: PropTypes.bool,
  updateUpdateBegin: PropTypes.func,
  deleteUpdateBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  currentEnterprise: PropTypes.object,
  links: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(UpdateList);
