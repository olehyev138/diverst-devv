import React from 'react';
import { Grid, Button } from '@material-ui/core';
import robot from 'images/robot.svg';
import PropTypes from 'prop-types';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/ErrorBoundary/messages';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    // Update state so the next render will show the fallback UI.
    return { hasError: true };
  }

  componentDidCatch(error, info) {
    // TODO: Handle the error
    /* eslint-disable-next-line no-console */
    console.log(error);
  }

  render() {
    if (this.state.hasError)
      // You can render any custom fallback UI
      return (
        <React.Fragment>
          <Grid
            container
            spacing={0}
            direction='column'
            alignItems='center'
            justify='center'
            style={{ minHeight: '100vh', textAlign: 'center' }}
          >
            <Grid item xs={6}>
              <img src={robot} alt='Oops!' height='150' width='150' />

              { /* TODO: translation strings */ }
              <h4><DiverstFormattedMessage {...messages.message} /></h4>
              <Button><DiverstFormattedMessage {...messages.home} /></Button>
            </Grid>
          </Grid>
        </React.Fragment>
      );


    return this.props.children;
  }
}

ErrorBoundary.propTypes = {
  children: PropTypes.node,
};

export default ErrorBoundary;
