/**
 * NotFoundPage
 *
 * This is the page we show when the user visits a url that doesn't have a route
 *
 */

import React from 'react';
import { FormattedMessage } from 'react-intl';
import { NavLink } from 'react-router-dom';
import classNames from 'classnames';
import PropTypes from 'prop-types';

import {
  Grid, Button, CardContent, Typography, Divider, Hidden
} from '@material-ui/core';
import HomeIcon from '@material-ui/icons/Home';

import messages from './messages';
import Logo from 'components/Logo';

import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  textCenter: {
    textAlign: 'center',
  },
  verticalMargins: {
    marginTop: 24,
    marginBottom: 24,
  },
});

export class NotFoundPage extends React.PureComponent {
  render() {
    // Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
    /* eslint-disable-next-line react/no-multi-comp */
    const WrappedNavLink = React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);

    const { classes } = this.props;

    return (
      <div className={classes.textCenter}>
        <Logo coloredDefault imgClass='extra-large-img' />
        <Typography variant='h6' className={classes.verticalMargins}>
          <FormattedMessage {...messages.header} />
        </Typography>
        <Divider />
        <Button
          variant='contained'
          color='primary'
          component={WrappedNavLink}
          to='/'
          className={classes.verticalMargins}
        >
          <Hidden xsDown>
            <HomeIcon />
          </Hidden>
          Return To Home
        </Button>
      </div>
    );
  }
}

NotFoundPage.propTypes = {
  classes: PropTypes.object,
};

export default withStyles(styles)(NotFoundPage);
