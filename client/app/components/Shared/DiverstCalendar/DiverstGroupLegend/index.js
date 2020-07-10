import React, { memo, useEffect, useRef, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { createMuiTheme, withStyles, withTheme, ThemeProvider } from '@material-ui/core/styles';
import { CircularProgress, Grid, Card, CardContent, Typography } from '@material-ui/core';

import 'stylesheets/main.scss';
import { createStructuredSelector } from 'reselect';
import { selectGroupIsLoading, selectPaginatedGroups } from 'containers/Group/selectors';
import { getColorsBegin, groupListUnmount } from 'containers/Group/actions';
import { connect } from 'react-redux';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';
import { formatColor } from 'utils/selectorHelpers';

const styles = theme => ({
  wrapper: {
    margin: theme.spacing(1),
    position: 'relative',
  },
  buttonProgress: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    marginTop: -12,
    marginLeft: -12,
  },
});

export function DiverstGroupLegend({ groups, isLoading, classes, ...rest }) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  useEffect(() => {
    rest.getColorsBegin();
    return () => rest.groupListUnmount();
  }, []);

  return (
    <Card>
      <div className={classes.wrapper}>
        <CardContent>
          <Grid container spacing={2}>
            {Object.values(groups).map(group => (
              <Grid item xs='auto' key={group.id}>
                <Typography style={{ color: formatColor(group.calendar_color) }}>
                  {group.name}
                </Typography>
              </Grid>
            ))}
          </Grid>
        </CardContent>
        {isLoading && (
          <Grid container justify='center' alignContent='center'>
            <Grid item>
              <CircularProgress size={80} thickness={1.5} className={classes.buttonProgress} />
            </Grid>
          </Grid>
        )}
      </div>
    </Card>
  );
}

DiverstGroupLegend.propTypes = {
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  groupListUnmount: PropTypes.func,
  getColorsBegin: PropTypes.func,
  groups: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string,
      calendar_color: PropTypes.string,
    })
  ),
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectGroupIsLoading(),
  groups: selectPaginatedGroups(),
});

const mapDispatchToProps = {
  getColorsBegin,
  groupListUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
  withTheme,
)(DiverstGroupLegend);
