/**
 * NotFoundPage
 *
 * This is the page we show when the user visits a url that doesn't have a route
 *
 */

import React from 'react';
import { FormattedMessage } from 'react-intl';

import { Grid, Button } from '@material-ui/core';
import { NavLink } from 'react-router-dom';

import messages from "./messages";
import Logo from 'components/Logo';

export class NotFoundPage extends React.PureComponent {
  render() {
    // Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
    const WrappedNavLink = React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);

    return (
      <div>
        <Grid
          container spacing={0} direction="column" alignItems="center"
          justify="center" style={{minHeight: '50vh', textAlign: "center"}}>
          <Grid item xs={6}>
            <Logo coloredDefault imgClass="extra-large-img" />
            <h3><FormattedMessage {...messages.header} /></h3>
            <Button component={WrappedNavLink} to='/home'>Home</Button>
          </Grid>
        </Grid>
      </div>
    );
  }
}

export default NotFoundPage;
