/**
 *
 * Region Leader Form Component
 *
 */
import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import {
  Card, CardActions, CardContent, Divider, TextField
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';

import { Field, Formik, Form } from 'formik';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Region/RegionLeaders/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';
import { buildValues, mapFields } from 'utils/formHelpers';
import { injectIntl, intlShape } from 'react-intl';


export function RegionLeaderFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const { links } = props;

  const membersSelectAction = (searchKey = '') => {
    props.getMembersBegin({
      count: 25, page: 0, order: 'asc',
      group_id: props.region.parent_id,
      query_scopes: ['active', ['user_search', searchKey]]
    });
  };


  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.regionLeader}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={Select}
              fullWidth
              id='user_id'
              name='user_id'
              label={<DiverstFormattedMessage {...messages.form.select} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.user_id}
              options={props.selectMembers}
              onChange={value => setFieldValue('user_id', value)}
              onInputChange={value => membersSelectAction(value)}
              onBlur={() => setFieldTouched('user_id', true)}
              isLoading={props.isLoadingMembers}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={Select}
              fullWidth
              id='user_role_id'
              name='user_role_id'
              label={<DiverstFormattedMessage {...messages.form.role} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.user_role_id}
              options={props.userRoles}
              onChange={value => setFieldValue('user_role_id', value)}
              onBlur={() => setFieldTouched('user_role_id', true)}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <TextField
              fullWidth
              id='position_name'
              name='position_name'
              label={<DiverstFormattedMessage {...messages.form.position} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.position_name}
              onChange={handleChange}
              onBlur={() => setFieldTouched('position_name', true)}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <DiverstCancel
              disabled={props.isCommitting}
              redirectFallback={links.index}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}
export function RegionLeaderForm(props) {
  const { intl } = props;

  const initialValues = buildValues(props.regionLeader, {
    id: { default: '' },
    user: { default: '', customKey: 'user_id' },
    region_id: { default: props.regionId },
    position_name: { default: intl.formatMessage(messages.form.position.default) },
    user_role: { default: '', customKey: 'user_role_id' },
    visible: { default: true },
    pending_member_notifications_enabled: { default: false },
    pending_comments_notifications_enabled: { default: false },
    pending_posts_notifications_enabled: { default: false },
    default_group_contact: { default: false },
  });
  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.regionLeaderAction(mapFields(values, ['user_id', 'user_role_id']));
      }}
      render={formikProps => <RegionLeaderFormInner {...props} {...formikProps} />}
    />
  );
}
RegionLeaderForm.propTypes = {
  intl: intlShape.isRequired,
  edit: PropTypes.bool,
  getRegionLeaderBegin: PropTypes.func,
  createRegionLeaderBegin: PropTypes.func,
  updateRegionLeaderBegin: PropTypes.func,
  getMembersBegin: PropTypes.func,
  selectMembers: PropTypes.array,
  userRoles: PropTypes.array,
  region: PropTypes.object,
  regionId: PropTypes.string,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  isLoadingMembers: PropTypes.bool,
  regionLeader: PropTypes.object,
  regionLeaderAction: PropTypes.func,
};

RegionLeaderFormInner.propTypes = {
  edit: PropTypes.bool,
  getRegionLeaderBegin: PropTypes.func,
  createRegionLeaderBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  regionLeader: PropTypes.object,
  region: PropTypes.object,
  regionId: PropTypes.string,
  buttonText: PropTypes.string,
  selectMembers: PropTypes.array,
  getMembersBegin: PropTypes.func,
  userRoles: PropTypes.array,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  touched: PropTypes.object,
  isCommitting: PropTypes.bool,
  isLoadingMembers: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string
  }),
};
export default compose(
  injectIntl,
  memo,
)(RegionLeaderForm);
