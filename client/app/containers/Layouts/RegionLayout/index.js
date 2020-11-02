import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';
import { withStyles } from '@material-ui/core/styles';

import RegionLinks from 'components/Region/RegionLinks';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Region/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Region/saga';

import { getRegionBegin, regionFormUnmount } from 'containers/Region/actions';
import { selectRegion, selectHasChanged, selectRegionIsFormLoading } from 'containers/Region/selectors';
import { createStructuredSelector } from 'reselect';

import Scrollbar from 'components/Shared/Scrollbar';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import { renderChildrenWithProps } from 'utils/componentHelpers';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    padding: theme.spacing(3),
  },
});

const RegionLayout = (props) => {
  useInjectReducer({ key: 'regions', reducer });
  useInjectSaga({ key: 'regions', saga });

  const { classes, currentRegion, ...rest } = props;

  /* - currentRegion will be wrapped around every container in the region section
   * - Connects to store & handles general current region state, such as current region object, layout
   */

  const { region_id: regionId } = useParams();

  useEffect(() => {
    if (regionId && currentRegion?.id !== regionId)
      rest.getRegionBegin({ id: regionId });

    return () => rest.regionFormUnmount();
  }, [regionId, rest.regionHasChanged]);

  const permission = name => currentRegion?.permissions?.[name];

  return (
    <React.Fragment>
      <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !currentRegion} TransitionChildProps={{ height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
        <RegionLinks currentRegion={currentRegion} permission={permission} {...rest} />
        <Scrollbar>
          <Fade in appear>
            <Container maxWidth='lg'>
              <div className={classes.content}>
                <React.Fragment>
                  {renderChildrenWithProps(props.children, { currentRegion, permission, ...rest })}
                </React.Fragment>
              </div>
            </Container>
          </Fade>
        </Scrollbar>
      </DiverstShowLoader>
    </React.Fragment>
  );
};

RegionLayout.propTypes = {
  children: PropTypes.any,
  classes: PropTypes.object,
  currentRegion: PropTypes.object,
  regionHasChanged: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentRegion: selectRegion(),
  isFormLoading: selectRegionIsFormLoading(),
  regionHasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getRegionBegin,
  regionFormUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  withStyles(styles),
  memo,
)(Conditional(
  RegionLayout,
  ['currentRegion.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.user.root.path(),
  permissionMessages.layouts.region
));
