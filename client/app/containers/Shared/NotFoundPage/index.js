/**
 * NotFoundPage
 *
 * This is the page we show when the user visits a url that doesn't have a route
 *
 */

import React from 'react';
import { FormattedMessage } from 'react-intl';
import PropTypes from 'prop-types';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  Button, Typography, Divider, Hidden
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import HomeIcon from '@material-ui/icons/Home';

import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Shared/NotFoundPage/messages';
import Logo from 'components/Shared/Logo';

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
          to={ROUTES.user.home.path()}
          className={classes.verticalMargins}
        >
          <Hidden xsDown>
            <HomeIcon />
          </Hidden>
          <FormattedMessage {...messages.return} />
        </Button>
      </div>
    );
  }
}

NotFoundPage.propTypes = {
  classes: PropTypes.object,
};

export default withStyles(styles)(NotFoundPage);
