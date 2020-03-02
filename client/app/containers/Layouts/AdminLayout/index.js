import React, { memo } from 'react';
import { compose } from 'redux';

import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';
import AdminLinks from 'components/Admin/AdminLinks';
import { withStyles } from '@material-ui/core/styles';
import AuthenticatedLayout from '../AuthenticatedLayout';
import PropTypes from 'prop-types';

import Scrollbar from 'components/Shared/Scrollbar';

const styles = theme => ({
  flex: {
    display: 'flex',
    height: '100%',
    minHeight: 0,
  },
  toolbar: theme.mixins.toolbar,
  container: {
    overflow: 'hidden',
  },
  content: {
    padding: theme.spacing(3),
  },
  block: {
    display: 'block',
    overflow: 'hidden',
  },
  scrollbarContentContainer: {
    flexDirection: 'column',
    display: 'flex',
    width: '100%',
    height: '100%',
    overflow: 'hidden',
    minHeight: 0,
  },
});

export class AdminLayout extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      drawerOpen: false,
    };
  }

  drawerToggleCallback = (drawerStatus) => {
    this.setState({ drawerOpen: drawerStatus });
  };

  componentDidUpdate(prevProps) {
    // Navigated
    if (this.props.location !== prevProps.location)
      /* eslint-disable-next-line react/no-did-update-set-state */
      this.setState({ drawerOpen: false });
  }

  render() {
    const { classes, ...other } = this.props;
    const Component = this.props.component;

    return (
      <AuthenticatedLayout
        drawerToggleCallback={this.drawerToggleCallback}
        drawerOpen={this.state.drawerOpen}
        position='relative'
        isAdmin
        {...other}
        component={matchProps => (
          <React.Fragment>
            <div className={classes.flex}>
              <AdminLinks
                drawerToggleCallback={this.drawerToggleCallback}
                drawerOpen={this.state.drawerOpen}
                location={other.location}
                {...matchProps}
              />
              <div className={classes.scrollbarContentContainer}>
                <Scrollbar>
                  <Fade in appear>
                    <Container maxWidth='xl' className={classes.container}>
                      <div className={classes.content}>
                        <Component {...other} />
                      </div>
                    </Container>
                  </Fade>
                </Scrollbar>
              </div>
            </div>
          </React.Fragment>
        )}
      />
    );
  }
}

AdminLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  location: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(AdminLayout);
