import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { AppBar, Toolbar, Button } from '@material-ui/core';
import { NavLink } from 'react-router-dom';
import { withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { pathId, fillPath, buildPath } from 'utils/routeHelpers';

export function GroupLinks(props) {
  const { theme } = props;
  const activeColor = theme.palette.primary.main;

  const NavLinks = () => (
    <Toolbar
      style={{
        float: 'none',
        marginLeft: 'auto',
        marginRight: 'auto'
      }}
    >
      <Button component={WrappedNavLink} to='/' activeStyle={{ color: activeColor }}>Home</Button>
      <Button component={WrappedNavLink} to='/user/campaigns' activeStyle={{ color: activeColor }}>Members</Button>
      <Button component={WrappedNavLink} to='events' activeStyle={{ color: activeColor }}>Events</Button>
      <Button component={WrappedNavLink} to='resources' activeStyle={{ color: activeColor }}>Resources</Button>
      { /* TODO: do this properly */ }
      <Button
        component={WrappedNavLink}
        to={buildPath(ROUTES.group.news.index.path, props, ['group_id'])}
        activeStyle={{ color: activeColor }}
      >
        News Feed
      </Button>
      <Button component={WrappedNavLink} to='/user/groups' activeStyle={{ color: activeColor }}>Manage</Button>
      <Button component={WrappedNavLink} to='/user/groups' activeStyle={{ color: activeColor }}>Plan</Button>
    </Toolbar>
  );

  return (
    <div>
      <AppBar position='static' style={{ backgroundColor: 'white' }}>
        <NavLinks />
      </AppBar>
    </div>
  );
}

GroupLinks.propTypes = {
  theme: PropTypes.object,
  computedMatch: PropTypes.shape({
    params: PropTypes.shape({
      id: PropTypes.string
    })
  }),
};

export function mapDispatchToProps(dispatch) {
  return {
    dispatch
  };
}

const mapStateToProps = createStructuredSelector({});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export default compose(
  withConnect,
)(withTheme(GroupLinks));
