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
  enterButtonLabel: {
    minWidth: 'max-content',
    fontSize: 18,
    fontWeight: 'bold',
    '& .MuiButton-endIcon': {
      marginTop: -2,
      '& svg': {
        fontSize: 24,
      },
    },
  },
  centerAlign: {
    textAlign: 'center', // Necessary as the grid item prop "align='center'" breaks the outlined input label layout slightly
  },
});

export function SSOLanding(props) {
  const { classes, handleEnter, ...rest } = props;

  return (
    <Box boxShadow={4} borderRadius={4} width='100%'>
      <Card raised className={classes.card} variant='outlined'>
        <CardContent className={classes.cardContent}>
          <Logo coloredDefault maxHeight='60px' />
          <Box pb={2} />
        </CardContent>
        <CardActions className={classes.cardActions}>
          <Grid container spacing={4} direction='column'>
            <Grid item>
              <div className={classes.centerAlign}>
                <LocaleToggle />
              </div>
            </Grid>
            <Grid item xs align='center'>
              <Button
                classes={{
                  label: classes.enterButtonLabel
                }}
                type='submit'
                color='primary'
                size='large'
                fullWidth
                variant='contained'
                endIcon={<EnterIcon fontSize='large' />}
                onClick={handleEnter}
              >
                {<FormattedMessage {...messages.enter} />}
              </Button>
            </Grid>
          </Grid>
        </CardActions>
      </Card>
    </Box>
  );
}

SSOLanding.propTypes = {
  classes: PropTypes.object,
  handleEnter: PropTypes.func.isRequired,
};

// without memo
export const StyledSSOLanding = compose(
  withStyles(styles),
)(SSOLanding);

export default compose(
  memo,
  withStyles(styles),
)(SSOLanding);
