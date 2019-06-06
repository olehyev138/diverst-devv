/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FormattedMessage } from 'react-intl';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import injectReducer from 'utils/injectReducer';
import reducer from './reducer';
import messages from './messages';

import {
  Typography, Button, Grid, Card, CardActions, CardContent, Paper
} from '@material-ui/core';
import { fade } from '@material-ui/core/styles/colorManipulator';
import { withStyles } from '@material-ui/core/styles';

import ApplicationHeader from 'components/ApplicationHeader';
import UserLinks from 'components/UserLinks';

const styles = theme => ({
  paper: {
    padding: theme.spacing(2),
    textAlign: 'center',
    color: theme.palette.text.secondary,
  },
  grow: {
    flexGrow: 1
  },
  title: {
    fontSize: 14,
    display: 'none',
    [theme.breakpoints.up('sm')]: {
      display: 'block'
    }
  },
  card: {
    minWidth: 275
  },
  bullet: {
    display: 'inline-block',
    margin: '0 2px',
    transform: 'scale(0.8)'
  },
  pos: {
    marginBottom: 12
  },
  toolbar: theme.mixins.toolbar,
});

/* eslint-disable react/prefer-stateless-function */
// TODO: can this be written with a stateless componenet?
export class HomePage extends React.PureComponent {
  constructor(props) {
    super(props);
  }

  state = {
    anchorEl: null,
    mobileMoreAnchorEl: null
  };

  handleProfileMenuOpen = (event) => {
    this.setState({ menuAnchor: event.currentTarget });
  };

  handleMenuClose = () => {
    this.setState({ menuAnchor: null });
    this.handleMobileMenuClose();
  };

  handleMobileMenuOpen = (event) => {
    this.setState({ mobileMoreAnchorEl: event.currentTarget });
  };

  handleMobileMenuClose = () => {
    this.setState({ mobileMoreAnchorEl: null });
  };

  componentWillMount() {}

  componentDidMount() {}

  render() {
    const { classes } = this.props;

    return (
      <React.Fragment>
        <Grid container spacing={6}>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
        <Grid container spacing={6}>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs={6}>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      </React.Fragment>
    );
  }
}

HomePage.propTypes = {
  currentUser: PropTypes.object,
  classes: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
});

export function mapDispatchToProps(dispatch, ownProps) {
  return {
    dispatch
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

const withReducer = injectReducer({ key: 'home', reducer });

export default compose(
  withReducer,
  withConnect,
  memo,
)(withStyles(styles)(HomePage));
