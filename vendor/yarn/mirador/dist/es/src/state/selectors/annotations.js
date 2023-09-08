import { createSelector } from 'reselect';
import filter from 'lodash/filter';
import flatten from 'lodash/flatten';
import AnnotationFactory from '../../lib/AnnotationFactory';
import { getCanvas, getVisibleCanvases } from './canvases';
var getAnnotationsOnCanvas = createSelector([getCanvas, function (state) {
  return state.annotations;
}], function (canvas, annotations) {
  if (!annotations || !canvas) return [];
  if (!annotations[canvas.id]) return [];
  return flatten(Object.values(annotations[canvas.id]));
});
var getPresentAnnotationsCanvas = createSelector([getAnnotationsOnCanvas], function (annotations) {
  return filter(Object.values(annotations).map(function (annotation) {
    return annotation && AnnotationFactory.determineAnnotation(annotation.json);
  }), function (annotation) {
    return annotation && annotation.present();
  });
});
var getAnnotationsOnSelectedCanvases = createSelector([getVisibleCanvases, function (state) {
  return state.annotations;
}], function (canvases, annotations) {
  if (!annotations || !canvases) return [];
  return flatten(canvases.map(function (c) {
    return c.id;
  }).map(function (targetId) {
    return annotations[targetId] && Object.values(annotations[targetId]);
  }));
});
var getPresentAnnotationsOnSelectedCanvases = createSelector([getAnnotationsOnSelectedCanvases], function (annotations) {
  return filter(Object.values(annotations).map(function (annotation) {
    return annotation && AnnotationFactory.determineAnnotation(annotation.json);
  }), function (annotation) {
    return annotation && annotation.present();
  });
});
/**
* Return an array of annotation resources filtered by the given motivation for a particular canvas
* @param {Array} annotations
* @param {Array} motivations
* @return {Array}
*/

export var getAnnotationResourcesByMotivationForCanvas = createSelector([getPresentAnnotationsCanvas, function (state, _ref) {
  var motivations = _ref.motivations;
  return motivations;
}], function (annotations, motivations) {
  return filter(flatten(annotations.map(function (annotation) {
    return annotation.resources;
  })), function (resource) {
    return resource.motivations.some(function (motivation) {
      return motivations.includes(motivation);
    });
  });
});
/**
* Return an array of annotation resources filtered by the given motivation
* @param {Array} annotations
* @param {Array} motivations
* @return {Array}
*/

export var getAnnotationResourcesByMotivation = createSelector([getPresentAnnotationsOnSelectedCanvases, function (state, _ref2) {
  var motivations = _ref2.motivations;
  return motivations;
}], function (annotations, motivations) {
  return filter(flatten(annotations.map(function (annotation) {
    return annotation.resources;
  })), function (resource) {
    return resource.motivations.some(function (motivation) {
      return motivations.includes(motivation);
    });
  });
});
/**
 * Return the selected annotations IDs of a given CanvasId
 * @param {Object} state
 * @param {String} windowId
 * @param {Array} targetIds
 * @return {Array}
 */

export var getSelectedAnnotationIds = createSelector([function (state, _ref3) {
  var windowId = _ref3.windowId;
  return state.windows[windowId].selectedAnnotations;
}, getVisibleCanvases], function (selectedAnnotations, canvases) {
  return canvases && flatten(canvases.map(function (c) {
    return c.id;
  }).map(function (targetId) {
    return selectedAnnotations && selectedAnnotations[targetId];
  })) || [];
});
export var getSelectedAnnotationsOnCanvases = createSelector([getPresentAnnotationsOnSelectedCanvases, getSelectedAnnotationIds], function (canvasAnnotations, selectedAnnotationIds) {
  return canvasAnnotations.map(function (annotation) {
    return {
      id: annotation['@id'] || annotation.id,
      resources: annotation.resources.filter(function (r) {
        return selectedAnnotationIds && selectedAnnotationIds.includes(r.id);
      })
    };
  }).filter(function (val) {
    return val.resources.length > 0;
  });
});
export var getHighlightedAnnotationsOnCanvases = createSelector([getPresentAnnotationsOnSelectedCanvases, function (state, _ref4) {
  var windowId = _ref4.windowId;
  return state.windows[windowId].highlightedAnnotation;
}, function (state, _ref5) {
  var windowId = _ref5.windowId;
  return state.windows[windowId].displayAllAnnotations;
}], function (canvasAnnotations, highlightedAnnotation, displayAllAnnotations) {
  if (displayAllAnnotations) return canvasAnnotations;

  if (highlightedAnnotation) {
    return canvasAnnotations.map(function (annotation) {
      return {
        id: annotation['@id'] || annotation.id,
        resources: annotation.resources.filter(function (r) {
          return highlightedAnnotation && highlightedAnnotation === r.id;
        })
      };
    }).filter(function (val) {
      return val.resources.length > 0;
    });
  }

  return [];
});