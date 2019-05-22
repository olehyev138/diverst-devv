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

import injectSaga from 'utils/injectSaga';
import injectReducer from 'utils/injectReducer';
import reducer from './reducer';
import saga from './saga';
import messages from './messages';

import { handleLogOut, setUser } from 'containers/App/actions';
import { selectToken, selectUser, selectEnterprise } from 'containers/App/selectors';

import { Typography, Button, Grid, Card, CardActions, CardContent, Paper } from "@material-ui/core";
import { fade } from '@material-ui/core/styles/colorManipulator';
import { withStyles } from '@material-ui/core/styles';

import ApplicationHeader from 'components/ApplicationHeader';
import UserLinks from 'components/UserLinks';

const styles = theme => ({
  root: {
    width: "100%",
    flexGrow: 1,
  },
  paper: {
    padding: theme.spacing.unit * 2,
    textAlign: 'center',
    color: theme.palette.text.secondary,
  },
  grow: {
    flexGrow: 1
  },
  title: {
    fontSize: 14,
    display: "none",
    [theme.breakpoints.up("sm")]: {
      display: "block"
    }
  },
  card: {
    minWidth: 275
  },
  bullet: {
    display: "inline-block",
    margin: "0 2px",
    transform: "scale(0.8)"
  },
  pos: {
    marginBottom: 12
  }
});

/* eslint-disable react/prefer-stateless-function */
// TODO: can this be written with a stateless componenet?
export class HomePage extends React.PureComponent {
  constructor(props) {
    super(props);
    this.handleLogOut = this.handleLogOut.bind(this);
    this.handleVisitAdmin = this.handleVisitAdmin.bind(this);
  }

  handleLogOut() {
    this.props.handleLogOut(this.props.currentUser);
  }

  handleVisitAdmin() {
    this.props.handleVisitAdmin();
  }

  state = {
    anchorEl: null,
    mobileMoreAnchorEl: null
  };

  handleProfileMenuOpen = event => {
    this.setState({ anchorEl: event.currentTarget });
  };

  handleMenuClose = () => {
    this.setState({ anchorEl: null });
    this.handleMobileMenuClose();
  };

  handleMobileMenuOpen = event => {
    this.setState({ mobileMoreAnchorEl: event.currentTarget });
  };

  handleMobileMenuClose = () => {
    this.setState({ mobileMoreAnchorEl: null });
  };

  componentWillMount() {}

  componentDidMount() {}

  render() {
    const { classes } = this.props;
    const bull = <span className={classes.bullet}>•</span>;

    return (
      <div className={classes.root}>
        <UserLinks/>
      </div>
    );
  }
}

HomePage.propTypes = {
  handleLogOut: PropTypes.func,
  currentUser: PropTypes.object,
  classes: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
  token: selectToken(),
  currentUser: selectUser(),
  enterprise: selectEnterprise()
});

export function mapDispatchToProps(dispatch, ownProps) {
  return {
//    handleLogOut: function(token) {
//      console.log('me too??');
//      dispatch(handleLogOut(token));
//      dispatch(setUser(null));
//    },
//    handleVisitAdmin: function() {
//      dispatch(push("/admins/analytics"));
//    }
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

const withReducer = injectReducer({ key: "home", reducer });
const withSaga = injectSaga({ key: "home", saga });

export default compose(
  withReducer,
  withSaga,
  withConnect,
  memo,
)(withStyles(styles)(HomePage));
