/**
 *
 * Emails List Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Card, CardContent, Grid, Link, Typography,
} from '@material-ui/core';

import messages from 'containers/GlobalSettings/Email/Email/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstPagination from 'components/Shared/DiverstPagination';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

const styles = theme => ({
  emailListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  emailLink: {
    '&:hover': {
      textDecoration: 'none',
    },
    '&:hover h2': {
      textDecoration: 'underline',
    },
  },
  dateText: {
    fontWeight: 'bold',
  },
  floatRight: {
    float: 'right',
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 24,
  },
});

export function EmailsList(props) {
  const { classes } = props;

  return (
    <React.Fragment>
      <DiverstLoader isLoading={props.isLoading} {...props.loaderProps}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.emails && props.emails.map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.emailListItem}>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Link
                  className={classes.emailLink}
                  component={WrappedNavLink}
                  to={{
                    pathname: props.links.emailEdit(item.id),
                    state: { id: item.id }
                  }}
                >
                  <Card>
                    <CardContent>
                      <Grid container spacing={1} justify='space-between' alignItems='center'>
                        <Grid item xs>
                          <Typography color='primary' variant='h6' component='h2'>
                            {item.name}
                          </Typography>
                          <hr className={classes.divider} />
                          <Box pt={1} />
                          <Typography color='textSecondary' variant='subtitle2' className={classes.dateText}>
                            {item.description}
                          </Typography>
                        </Grid>
                      </Grid>
                    </CardContent>
                  </Card>
                </Link>
              </Grid>
            );
          })}
          {props.emails && props.emails.length <= 0 && (
            <React.Fragment>
              <Grid item sm>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <DiverstFormattedMessage {...messages.index.empty} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
      </DiverstLoader>
      {props.emails && props.emails.length > 0 && (
        <DiverstPagination
          isLoading={props.isLoading}
          count={props.emailsTotal}
          handlePagination={props.handlePagination}
        />
      )}
    </React.Fragment>
  );
}

EmailsList.propTypes = {
  classes: PropTypes.object,
  emails: PropTypes.array,
  emailsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
  loaderProps: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(EmailsList);
