/**
 *
 * SSOLanding
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { FormattedMessage } from 'react-intl';

import { withStyles } from '@material-ui/core/styles';
import withWidth from '@material-ui/core/withWidth';

import { Button, Card, CardActions, CardContent, Grid, Box } from '@material-ui/core';

import EnterIcon from '@material-ui/icons/DoubleArrow';

import messages from 'containers/Session/SSOLandingPage/messages';

import Logo from 'components/Shared/Logo';

import LocaleToggle from 'containers/Shared/LocaleToggle';

const styles = theme => ({
  card: {
    width: '100%',
    borderColor: theme.palette.primary.main,
  },
  cardContent: {
    textAlign: 'center',
  },
  cardActions: {
    paddingTop: 4,
    paddingLeft: 16,
    paddingRight: 16,
    paddingBottom: 16,
  },
  submitButtonLabel: {
    minWidth: 'max-content',
  },
  centerAlign: {
    textAlign: 'center', // Necessary as the grid item prop "align='center'" breaks the outlined input label layout slightly
  },
});

export function SSOLanding(props) {
  const { classes, width, handleEnter, ...rest } = props;

  return (
    <Box boxShadow={4} borderRadius={4} width='100%'>
      <Card raised className={classes.card} variant='outlined'>
        <CardContent className={classes.cardContent}>
          <Logo coloredDefault maxHeight='60px' />
          <Box pb={2} />
        </CardContent>
        <CardActions className={classes.cardActions}>
          <Grid container spacing={1} alignItems='center' justify='space-between' direction='row-reverse'>
            <Grid item xs={8} sm={6} align={width === 'xs' ? 'left' : 'center'}>
              <Button
                classes={{
                  label: classes.submitButtonLabel
                }}
                type='submit'
                color='primary'
                size='large'
                variant='contained'
                endIcon={<EnterIcon />}
                onClick={handleEnter}
              >
                {<FormattedMessage {...messages.enter} />}
              </Button>
            </Grid>
            <Grid item xs={12} sm>
              <div className={classes.centerAlign}>
                <LocaleToggle />
              </div>
            </Grid>
          </Grid>
        </CardActions>
      </Card>
    </Box>
  );
}

SSOLanding.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  handleEnter: PropTypes.func.isRequired,
};

// without memo
export const StyledSSOLanding = compose(
  withWidth(),
  withStyles(styles),
)(SSOLanding);

export default compose(
  memo,
  withWidth(),
  withStyles(styles),
)(SSOLanding);
